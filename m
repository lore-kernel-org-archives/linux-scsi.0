From: Steve McIntyre <steve@einval.com>
Subject: Re: sense buffer length for REQUEST SENSE?
Date: Sat, 27 Jul 2002 09:50:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020727085013.GB2624@einval.com>
References: <3D420D77.A4633D9C@splentec.com> <3D4225D5.9A8ED692@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D4225D5.9A8ED692@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Jul 27, 2002 at 12:47:17AM -0400, Douglas Gilbert wrote:
>Luben Tuikov wrote:
>> client has gotten all the sense data the sense buffer
>> should be 252 bytes.
>
>Yes I can see that number in SPC-3. Has anyone every seen
>an actual REQUEST SENSE response (sense buffer) anywhere near 
>that size? The new "descriptor" sense data format should
>further reduce the size requirement.

Looking at the SCSI spec of a 12" WORM autoloader I've worked with, it
uses up to 246 bytes...

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
Support the Campaign for Audiovisual Free Expression: http://www.eff.org/cafe/
