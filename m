From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] scsi: storvsc: Set the SRB flags correctly when no
 data transfer is needed
Date: Mon, 11 May 2015 02:10:09 -0700
Message-ID: <20150511091009.GE28820@infradead.org>
References: <1429921403-8606-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429921403-8606-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 24, 2015 at 05:23:23PM -0700, K. Y. Srinivasan wrote:
> Set the SRB flags correctly when there is no data transfer.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
