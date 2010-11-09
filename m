From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm: Convert backstore ->set_configfs_dev_params() to
	use parser.h
Date: Tue, 09 Nov 2010 02:03:21 -0800
Message-ID: <1289297001.19946.92.camel@haakon2.linux-iscsi.org>
References: <1289296122-13152-1-git-send-email-nab@linux-iscsi.org>
	 <20101109100359.GA26324@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52383 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KIKId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 05:08:33 -0500
In-Reply-To: <20101109100359.GA26324@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Tue, 2010-11-09 at 05:03 -0500, Christoph Hellwig wrote:
> > +	opts = kstrdup(page, GFP_KERNEL);
> 
> What do you need the this copy for?
> 
> Otherwise looks good.
> 

<nod> thanks for the pointer here..

Btw, the kstrdup() is required because the configfs attribute store
function will be passing a 'const char *page' that is propigated from
target_core_configfs.c: target_core_store_dev_control() out to
->set_configfs_dev_params() backend code.






