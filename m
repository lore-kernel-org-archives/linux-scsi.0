From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: add cciss_allow_hpsa module parameter
Date: Mon, 22 Apr 2013 15:10:38 -0700
Message-ID: <20130422151038.6273759a2172b81ebd84e1af@linux-foundation.org>
References: <20130418184937.GA31252@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130418184937.GA31252@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 18 Apr 2013 13:49:37 -0500 Mike Miller <mike.miller@hp.com> wrote:

> Add the cciss_allow_hpsa modules parameter. This allows users to use the hpsa
> driver instead of cciss for older controllers.
> Tested with 3.9.0-rc7 in combination with the bug fix submitted Tuesday. My
> apologies for not testing that patch with the correct kernel.

Could you please resend Tuesday's bug fix, with a much better
explanation than v1 had?  It's totally weird and wonderful that there's
an interaction between kdump and one scsi/block driver so let's try to
get a diagnosis into the record.
