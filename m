From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 1/3] badblocks: Add core badblock management code
Date: Tue, 24 Nov 2015 12:19:56 -0700
Message-ID: <5654B85C.7000409@fb.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
 <1448066960-20119-2-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448066960-20119-2-git-send-email-vishal.l.verma@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 05:49 PM, Vishal Verma wrote:
> Take the core badblocks implementation from md, and make it generally
> available. This follows the same style as kernel implementations of
> linked lists, rb-trees etc, where you can have a structure that can be
> embedded anywhere, and accessor functions to manipulate the data.
>
> The only changes in this copy of the code are ones to generalize
> function/variable names from md-specific ones. Also add init and free
> functions.

Split this into a .c file with the code.

-- 
Jens Axboe

