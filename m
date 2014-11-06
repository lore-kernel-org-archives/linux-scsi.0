From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/10] libata: use __scsi_format_command()
Date: Wed, 5 Nov 2014 23:02:25 -0800
Message-ID: <20141106070225.GB19721@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415088409-46590-5-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 09:06:43AM +0100, Hannes Reinecke wrote:
> libata already uses an internal buffer, so we should be using
> __scsi_format_command() here.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
