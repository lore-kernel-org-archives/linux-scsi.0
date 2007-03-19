From: Olaf Hering <olh@suse.de>
Subject: Re: improve sg_luns output for iscsi
Date: Mon, 19 Mar 2007 10:06:23 +0100
Message-ID: <20070319090623.GA25129@suse.de>
References: <20070306180428.GA16826@suse.de> <45EDC0A5.804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:33159 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbXCSJG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 05:06:29 -0400
Content-Disposition: inline
In-Reply-To: <45EDC0A5.804@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 06, Douglas Gilbert wrote:

> In summary sg_luns is probably not what you want!

Yes, it can be done in bash.

cd /sys/block/sde/device ; i=`pwd -P` ; printf '%x%012x\n' ${i##*:}
