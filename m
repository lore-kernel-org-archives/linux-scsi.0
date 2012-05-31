From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
Date: Thu, 31 May 2012 15:37:21 +0200
Message-ID: <20120531133720.GA21281@x1.osrc.amd.com>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
 <20120530182239.GD15635@x1.osrc.amd.com>
 <CABE8wwsw98KZS0W1sJghzrei0mSGLiMoh+7Wn5xOzdM54qiYqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABE8wwsw98KZS0W1sJghzrei0mSGLiMoh+7Wn5xOzdM54qiYqA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mroos@linux.ee, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 30, 2012 at 11:29:23AM -0700, Dan Williams wrote:
> They're ready for a run, but are likely 3.6 material.  For 3.5 I think
> James is going with the smaller fix posted here:
> 
> http://marc.info/?l=linux-scsi&m=133796775807498&w=2

Yep,

both the smaller fix and the 4-patch set cure the box here, thanks.

Tested-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
