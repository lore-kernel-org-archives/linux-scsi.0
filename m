From: Alan Dayley <alandd@consultpros.com>
Subject: SCSI phase control possible?
Date: Thu, 20 Nov 2003 23:27:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311202328.01650.alandd@consultpros.com>
Reply-To: alandd@consultpros.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mclean.mail.mindspring.net ([207.69.200.57]:23072 "EHLO
	mclean.mail.mindspring.net") by vger.kernel.org with ESMTP
	id S264312AbTKUG2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2003 01:28:05 -0500
Received: from h-66-167-43-179.phndaz91.dynamic.covad.net ([66.167.43.179] helo=192.168.200.100)
	by mclean.mail.mindspring.net with esmtp (Exim 3.33 #1)
	id 1AN4lv-0005rj-00
	for linux-scsi@vger.kernel.org; Fri, 21 Nov 2003 01:28:03 -0500
Content-Description: clearsigned data
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have the need to control, as fine grain as possible, the SCSI commands 
coming from a SCSI host.  For example, on a write command I want to be able 
to arbitrarily control the time from the identify message to the command and 
then control the time from the command to the actual data transfer, and so 
on.

Is there a SCSI driver that already allows this sort of control?

If not, do you have any thoughts on which driver would be the easiest to alter 
to create this level of control?

Or is this something too difficult to do with off the shelf HBAs and I'll have 
to start by making hardware?

I thought I'd ask knowledgable people before I start digging around in the 
code for the various drivers.

Alan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/vbBvUIl18h7/dy4RAjS5AJ0fK6Oua/zMynhNNyPgMslBABpJNwCfXAlr
WRJo0WtX6eoxD18j4kN50Mw=
=TYVG
-----END PGP SIGNATURE-----

