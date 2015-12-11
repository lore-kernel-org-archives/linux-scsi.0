From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 0/3] Badblock tracking for gendisks
Date: Thu, 10 Dec 2015 21:40:57 -0800
Message-ID: <CAPcyv4jaQN9L3=wUap=XXVAsUkdzUqCb6cOHnqGQH9JpV_sJcw@mail.gmail.com>
References: <1449602295-28781-1-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:36725 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbLKFk6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2015 00:40:58 -0500
Received: by qgcc31 with SMTP id c31so185698712qgc.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 21:40:58 -0800 (PST)
In-Reply-To: <1449602295-28781-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Vishal Verma <vishal.l.verma@intel.com>, Christoph Hellwig <hch@lst.de>

Hi Jens,

Are you on-board with this approach?  Any concerns with me carrying
this through the nvdimm tree along with our other pending
error-handling enabling?
