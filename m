From: Matthew Wilcox <willy@debian.org>
Subject: Re: [patch] sym53c8xx_2 uses SYM_MEM_CLUSTER_SHIFT before its #define'd
Date: Sat, 7 Feb 2004 20:45:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040207204532.GA24334@parcelfarce.linux.theplanet.co.uk>
References: <20040207203058.GA7388@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040207203058.GA7388@fs.tum.de>
To: Adrian Bunk <bunk@fs.tum.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 07, 2004 at 09:30:58PM +0100, Adrian Bunk wrote:
> This seems to be a bug:
> SYM_MEM_CLUSTER_SIZE is used before it's #define'd.
> 
> The patch below fixes this issue.

Thanks, I've taken this patch too.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
