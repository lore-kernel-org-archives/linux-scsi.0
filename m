From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] megaraid: update version reported by MEGAIOC_QDRVRVER
Date: Tue, 24 Apr 2007 15:53:18 -0500
Message-ID: <462E6E3E.4070901@redhat.com>
References: <20070419171024.GA6885@dhcp-210.hsv.redhat.com> <20070424191049.GA24974@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423049AbXDXUul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 16:50:41 -0400
In-Reply-To: <20070424191049.GA24974@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 19, 2007 at 12:10:24PM -0500, David Milburn wrote:
> 
>>Update the driver version reported by MEGAIOC_QDRVRVER to
>>match LSI_COMMON_MOD_VERSION.
> 
> 
> Why does this matter?
> 

It is needed so that the correct driver version is reported
by user-space tools that use the MEGAIOC_QDRVRVER ioctl
to query the driver version.

David

