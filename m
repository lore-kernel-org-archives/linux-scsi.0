From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Wed, 5 Mar 2003 17:13:47 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030305171347.A17467@beaverton.ibm.com>
References: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Thu, Mar 06, 2003 at 02:01:38AM +0100
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

Andries -

On Thu, Mar 06, 2003 at 02:01:38AM +0100, Andries.Brouwer@cwi.nl wrote:
> See that 2.5.64 came out - good. Time to send the next dev_t patch.
> Unfortunately 2.5.63 and 2.5.64 do not boot.

Did you try the patch to scsi_error.c Mike A. recently posted?

> [I can make 2.5.64 boot if I make sure no errors ever occur.
> That means that I must disable get_evpd_page, get_serialnumber,
> get_cachetype that my old stuff doesnt know about.
> If I do that all is well.]

That sucks - even if error handling recovers from them.

-- Patrick Mansfield
