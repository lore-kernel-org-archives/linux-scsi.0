From: Ashutosh Naik <ashutosh.naik-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute  structure in sysfs
Date: Sat, 11 Apr 2009 23:43:48 +0530
Message-ID: <81083a450904111113k4f2dd50et18585bf3c2dce8f2@mail.gmail.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com> <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0016e643594850546404674b7167"
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1239472568.3416.11.camel-0iu6Cu4xQGLV0bN/WMK0Sm4KqUE0Tg80jeSHHoATDr/QT0dZR+AlfA@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, konradr-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ketuzsezr-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org, "Vishnu V. Mandyam" <vishnu-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--0016e643594850546404674b7167
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 11, 2009 at 11:26 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

> What do these signoffs mean?

I am reattaching the patch here:

Description:This patch fixes the display of a few fields in the iBFT
NIC attribute
structure in sysfs.

Signed-off-by: Ashutosh Naik <ashutosh.naik-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vishnu V<vishnu-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

> The second question is who picks this up? =A0The drivers/firmware
> directory doesn't seem to have a dedicated tree, so I can take this
> through the SCSI tree if required or Andrew can take it through -mm.

This is used for display of the various structures of the iBFT table
via sysfs and can be picked up by any iSCSI initiator driver module
that uses the information in the iBFT table to boot over iSCSI, such
as open-iscsi.

--~--~---------~--~----~------------~-------~--~----~
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe@google=
groups.com
For more options, visit this group at http://groups.google.com/group/open-i=
scsi
-~----------~----~----~----~------~----~------~--~---


--0016e643594850546404674b7167
Content-Type: text/plain
Content-Transfer-Encoding: base64
Content-Disposition: inline;
	filename="iscsi_ibft_c_fix_nic_attribute_display_in_sysfs.txt"
X-Attachment-Id: f_ftemesao0

ZGlmZiAtcnVOIGxpbnV4LTIuNi4yOS4xLW9yaWcvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0
LmMgbGludXgtMi42LjI5LjEvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0LmMKLS0tIGxpbnV4
LTIuNi4yOS4xLW9yaWcvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0LmMJMjAwOS0wNC0xMSAx
ODoyNTo0MC4wMDAwMDAwMDAgKzA1MzAKKysrIGxpbnV4LTIuNi4yOS4xL2RyaXZlcnMvZmlybXdh
cmUvaXNjc2lfaWJmdC5jCTIwMDktMDQtMTEgMTg6MzM6NDIuMDAwMDAwMDAwICswNTMwCkBAIC03
NTQsMTEgKzc1NCwxMSBAQAogCQlyYyA9IDE7CiAJCWJyZWFrOwogCWNhc2UgaWJmdF9ldGhfaXBf
YWRkcjoKLQkJaWYgKCFtZW1jbXAobmljLT5kaGNwLCBudWxscywgc2l6ZW9mKG5pYy0+ZGhjcCkp
KQorCQlpZiAobWVtY21wKG5pYy0+aXBfYWRkciwgbnVsbHMsIHNpemVvZihuaWMtPmlwX2FkZHIp
KSkKIAkJCXJjID0gMTsKIAkJYnJlYWs7CiAJY2FzZSBpYmZ0X2V0aF9zdWJuZXRfbWFzazoKLQkJ
aWYgKCFtZW1jbXAobmljLT5kaGNwLCBudWxscywgc2l6ZW9mKG5pYy0+ZGhjcCkpKQorCQlpZiAo
bmljLT5zdWJuZXRfbWFza19wcmVmaXgpCiAJCQlyYyA9IDE7CiAJCWJyZWFrOwogCWNhc2UgaWJm
dF9ldGhfb3JpZ2luOgo=
--0016e643594850546404674b7167--
