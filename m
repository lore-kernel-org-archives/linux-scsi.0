From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [LSF/MM TOPIC] Patch Submission process and Handling Internal
 Conflict
Date: Wed, 24 Jan 2018 11:20:13 -0800
Message-ID: <c4598a9a-6995-d67a-dd1c-8e946470eeb4@oracle.com>
References: <1516820744.3073.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1516820744.3073.30.camel@HansenPartnership.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 01/24/2018 11:05 AM, James Bottomley wrote:
> I've got two community style topics, which should probably be discussed
> in the plenary
> 
> 1. Patch Submission Process
> 
> Today we don't have a uniform patch submission process across Storage,
> Filesystems and MM.  The question is should we (or at least should we
> adhere to some minimal standards).  The standard we've been trying to
> hold to in SCSI is one review per accepted non-trivial patch.  For us,
> it's useful because it encourages driver writers to review each other's
> patches rather than just posting and then complaining their patch
> hasn't gone in.  I can certainly think of a couple of bugs I've had to
> chase in mm where the underlying patches would have benefited from
> review, so I'd like to discuss making the one review per non-trival
> patch our base minimum standard across the whole of LSF/MM; it would
> certainly serve to improve our Reviewed-by statistics.

Well, the mm track at least has some discussion of this last year:
https://lwn.net/Articles/718212/

-- 
Mike Kravetz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
