From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 05:59:52 -0600
Message-ID: <20090716115952.GR24310@parisc-linux.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 16, 2009 at 12:43:55AM +0100, Matthew Garrett wrote:
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index b62a097..b099493 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -421,6 +421,7 @@ struct scsi_host_template {
>  	 */
>  	unsigned unchecked_isa_dma:1;
>  
> +
>  	/*
>  	 * True if this host adapter can make good use of clustering.
>  	 * I originally thought that if the tablesize was large that it

Spurious hunk ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
