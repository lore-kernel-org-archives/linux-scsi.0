From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Wed, 5 Mar 2003 22:49:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306064921.GA1425@beaverton.ibm.com>
References: <UTC200303060639.h266dIo22884.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200303060639.h266dIo22884.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andries.Brouwer@cwi.nl [Andries.Brouwer@cwi.nl] wrote:
> > See if this fixes it..
> 
> No, I am afraid not. My infinite loop does not pass through
> scsi_eh_ready_devs().
> 

Can you send me your console log. If you have scsi_logging=1 that would
be greate also.

-andmike
--
Michael Anderson
andmike@us.ibm.com

