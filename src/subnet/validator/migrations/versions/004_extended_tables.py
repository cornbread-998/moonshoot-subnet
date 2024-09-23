"""extended tables

Revision ID: 004
Revises: 003
Create Date: 2024-09-23 21:56:53.496648

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '004'
down_revision: Union[str, None] = '003'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('miner_discoveries', sa.Column('user_name', sa.String(), nullable=False))
    op.add_column('miner_receipts', sa.Column('user_id', sa.String(), nullable=False))
    op.add_column('miner_receipts', sa.Column('user_name', sa.String(), nullable=False))
    op.add_column('miner_twitter_posts_blacklist', sa.Column('reason', sa.String(), nullable=True))
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('miner_twitter_posts_blacklist', 'reason')
    op.drop_column('miner_receipts', 'user_name')
    op.drop_column('miner_receipts', 'user_id')
    op.drop_column('miner_discoveries', 'user_name')
    # ### end Alembic commands ###
