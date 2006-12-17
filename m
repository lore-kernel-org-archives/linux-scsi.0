From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/5] iscsi bug fixes
Date: Sun, 17 Dec 2006 12:17:08 -0600
Message-ID: <458589A4.10802@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50744 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbWLQSaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 13:30:25 -0500
Received: from [192.168.0.7] (c-75-73-64-158.hsd1.mn.comcast.net [75.73.64.158])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id kBHIHEf7028762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 17 Dec 2006 12:17:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

These are bug fixes for LSI support, big endian fix for sense len
calculation, digest porting errors, and printing output. There have been
several iscsi patches floating around from Andrew and other users and
this incorporates those patches.

The patches were made over scsi-misc, but apply to Linus's current git
tree. One patch applies at a offset because of some of the queue work
changes in linus's tree but it is ok.
