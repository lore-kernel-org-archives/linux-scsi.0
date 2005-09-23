From: Mark Lord <liml@rtr.ca>
Subject: Re: SATA Drive Information (vs hdparm -i)?
Date: Thu, 22 Sep 2005 21:50:44 -0400
Message-ID: <43335F74.60506@rtr.ca>
References: <7744a2840509221206254d2109@mail.gmail.com> <43334AFF.8010901@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43334AFF.8010901@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: Richard Bollinger <rabollinger@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The current hdparm release does "-i" and "-I" out of the box,
along with many other "-[A-Z]" options,
assuming your kernel has the widely used libata "passthru" patch applied.

Since libata is in-theory to be decoupled from the SCSI layer at some point,
it might be unwise to rely on emulated SCSI commands for detailed SATA info.

Cheers
