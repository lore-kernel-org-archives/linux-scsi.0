From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/6 2.6.29-rc] cxgb3i -- bug fixes for 2.6.29-rcX
Date: Fri, 13 Feb 2009 21:38:39 -0800
Message-ID: <200902140538.n1E5cdOa014319@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


[PATCH v2 0/6 2.6.29-rc] cxgb3i -- bug fixes for 2.6.29-rcX=20

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Hi, Mike,

Could you review the following patches?

I've clamped down the max. outgoing pdu payload based on how much data can =
be fitted into a skb (either in the headroom or the frag_list), and removed=
 the extra memory allocation in alloc_pdu(). The scanning of the scsi scatt=
er-gather list is moved from alloc_pdu() to init_pdu().

The patches are based on scsi-rc-fixes-2.6 git.

The changes include:

- fixed tx work-request credit list.
- Added per-task data to track the state of the pdus to be transmitted.
- fixed a bug in tx pdu construction where we could over-run the skb's frag=
ment list.
- Added missing include file in cxgb3i_ddp.h.
- fixed spelling error in the documentation.
- Update version number to 1.0.1.


Thanks.
Karen
