From: Jerome Martin <jxm@risingtidesystems.com>
Subject: rtsadmin is now targetcli, new git repo.
Date: Tue, 20 Sep 2011 12:05:56 +0200
Message-ID: <CAN4SboBR5KpSEBaESij0tX6Kz6twSVuKLYeOfbvspdBSBC0h2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51580 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1ITKF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 06:05:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@>

Hello everyone,

As discussed on the target-devel mailing-list, and at community
request, the target administration tool previously known as "rtsadmin
community edition" is now simply named "targetcli". License (AGPLv3)
is unchanged.

The name change has been propagated to the source code, package names
and directory structure.
The previous "rtsadmin" git repository at
http://www.risingtidesystems.com/git/ still exists but is now obsolete
and won't be updated. It will be deleted soon.

The new repository is:

* GitWeb: targetcli on http://www.risingtidesystems.com/git/
* Git: git://risingtidesystems.com/targetcli.git or
git://linux-iscsi.org/targetcli.git

Please test the new repository to make sure I did not break too many
things during the name change, and update your pointers. The next
change to that repo will be a split Makefile, the one in git main tree
will take care of generating an official versioned out-of-tree tarball
for distributions package maintainers use, and the one inside the
tarball will provide expected package building targets. The currently
empty documentation package will also be removed from that next
version.

Once those changes are done and tested, I expect tagging version 2.0.

Best Regards,
--=20
J=E9r=F4me Martin
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
