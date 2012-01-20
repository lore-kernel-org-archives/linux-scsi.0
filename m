From: Tony Asleson <tasleson@redhat.com>
Subject: [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Fri, 20 Jan 2012 11:50:57 -0600
Message-ID: <4F19A981.4080502@redhat.com>
Reply-To: tasleson@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2ATRu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2012 12:50:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

I would like to give a brief background on the storage management API
and library that I have been working on** and discuss the design and
implementation challenges that I have encountered thus far.

Most notable is the same topic Shyam Iyer brought up about proprietary
plug-in support (http://marc.info/?l=linux-scsi&m=132454179114038&w=2).
This very feature has influenced libStorageMgmt heavily and has raised a
number of discussions on design and licensing.

Discussion topics
* Scope (What a storage library should/should not do)
* Role (library position in management stack)
* Features (specific: must have to would be nice)
* Usage scenarios which highlight needed features
* Licensing (most appropriate open source license)
* Proprietary plug-in support


** http://sourceforge.net/apps/trac/libstoragemgmt

Regards,
Tony Asleson
