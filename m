From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Date: Fri, 17 Oct 2014 06:26:11 -0700
Message-ID: <20141017132611.GM16538@infradead.org>
References: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: JBottomley@parallels.com, Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 14, 2014 at 06:38:53AM -0700, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Resolve some missing-field-initializers warnings by using
> designated initialization.

What tool is warning about these?  This construct is perfectly valid C.
