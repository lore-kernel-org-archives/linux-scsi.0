From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/8] scsi_sysfs: add 'is_bin_visible' callback
Date: Tue, 1 Mar 2016 12:56:53 +0800
Message-ID: <56D52115.4030000@suse.com>
References: <1456807872-88797-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:33685 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbcCAE5U (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Mon, 29 Feb 2016 23:57:20 -0500
In-Reply-To: <1456807872-88797-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/01/2016 12:51 PM, Hannes Reinecke wrote:
> Add 'is_bin_visible' callback to blank out unsupported vpd pages.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
Sorry, this is actually a stand-alone patch.
I'll be resending it with the proper subject.

Cheers,

Hannes

