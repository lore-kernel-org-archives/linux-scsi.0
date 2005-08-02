From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Location of the SCSI git trees has moved (again, sorry)
Date: Tue, 02 Aug 2005 12:31:16 -0500
Message-ID: <1123003876.5029.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40364 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261695AbVHBRbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2005 13:31:18 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j72HVHA20941
	for <linux-scsi@vger.kernel.org>; Tue, 2 Aug 2005 13:31:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

With git evolving so rapidly, it proved a bit difficult for me to keep
the www.parisc-linux.org up to date with both git and the web browser.
Plus, since it's a test machine for parisc-debian, we've been having
some stability issues with it that seemed to be exacerbated by hosting
the git trees on it.

For that reason, I've moved the trees to www.kernel.org, where someone
else looks after both git and gitweb ...

The locations are

Trees for http pull (or rsync, substituting with rsync://)

http://www.kernel.org/pub/scm/linux/kernel/git/jejb/

Gitweb is slightly more complex; 

http://www.kernel.org/git

shows everyone's git tree on kernel.org; you have to scroll down to the
four or so trees under my name to begin browsing them.

The changelogs and diffs are under

http://www.kernel.org/pub/linux/kernel/people/jejb/

James


