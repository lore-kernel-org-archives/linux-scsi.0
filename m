From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: [2.6 patch] dpt_i2o fix for deadlock condition
Date: Tue, 29 Nov 2005 13:04:37 -0500
Message-ID: <20051129180437.GB3803@csclub.uwaterloo.ca>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3DD6C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perpugilliam.csclub.uwaterloo.ca ([129.97.134.31]:20369 "EHLO
	perpugilliam.csclub.uwaterloo.ca") by vger.kernel.org with ESMTP
	id S932291AbVK2SEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 13:04:38 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3DD6C@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org

On Tue, Nov 29, 2005 at 11:51:25AM -0500, Salyzyn, Mark wrote:
> Miquel van Smoorenburg <miquels@cistron.nl> forwarded me this fix to
> resolve a deadlock condition that occurs due to the API change in
> 2.6.13+ kernels dropping the host locking when entering the error
> handling. They all end up calling adpt_i2o_post_wait(), which if you
> call it unlocked, might return with host_lock locked anyway and that
> causes a deadlock.
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> 
>  drivers/scsi/dpt_i2o.c |    25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> Patch attached to email due to Outlook corrupting content when inlined.

There must still be a way to tell outlook to make the type something
useful, rather than application/octet-stream.  maybe if the extension
was .patch.txt it would do something smarter.

Len Sorensen
