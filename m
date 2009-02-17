From: david@lang.hm
Subject: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 14:24:27 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:59302 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZBQVT2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 16:19:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

I have some systems with the MPT fusion raid cards in them and SAS drives, 
they work find on the 2.6.24 'etch and a half' debian kernel, but when I 
try and install a 2.6.28 kernel there are numerous timeouts during boot 
and the raid array is not recognised.

I tried a 2.6.27 kernel I have laying around and got the same results with 
it.

is this a known problem with a work-around? or am I just lucky enough to 
be the only one hitting this?

David Lang
