From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [Patch] target: remove needless include of version.h
Date: Fri, 19 Aug 2011 09:07:25 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net>
References: <1313736815-27234-1-git-send-email-amwang@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1313736815-27234-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: WANG Cong <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 19 Aug 2011, WANG Cong wrote:

> They don't version.h to be compiled. Compiling tested.
> 

Looks more or less identical to the patch I submitted on Aug 1 (and 
earlier) : https://lkml.org/lkml/2011/8/1/309


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
