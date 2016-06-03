From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] Add P3 support, define reg & struct
Date: Fri, 03 Jun 2016 09:04:15 -0400
Message-ID: <1464959055.21292.14.camel@linux.vnet.ibm.com>
References: <1464955904-16738-1-git-send-email-ch1102chiou@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464955904-16738-1-git-send-email-ch1102chiou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: Paul <paul.lyu@tw.promise.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-06-03 at 20:11 +0800, Charles Chiou wrote:
> From: Paul <paul.lyu@tw.promise.com>
> 
> 1.Change ver
> 2.Add P3 VID & DID
> 2.Define device reg
> 3.Add P3 struct and callback
> 
> Signed-off-by: Paul <paul.lyu@tw.promise.com>

If you're sending the patches, this needs your signoff as well.

Also, it looks like these 5 all need to be applied as one, so can you
send a change log for the combined patch set saying what it is and what
it does (basically, what is the P3 and how does it differ from previous
stex models?)

Thanks,

James
