From: Luben Tuikov <luben@splentec.com>
Subject: Re: Autosense requirement
Date: Tue, 30 Jul 2002 15:58:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D46EFFF.7B8D4BAE@splentec.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net> <20020729155518.B20905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> 
> It will be mandatory for the LLDD to do autosense.  All remnants of code
> to perform a follow up request sense operation *will* dissappear from the
> mid layer.  OTOH, the sense command and sense buffer will be pre-set for
> each device so at least the LLDD won't have to build their own command any
> longer, they can just change the command pointer from the original command
> to the sense command and the data buffer to the sense buffer and reissue
> the request.

Oh, this is soooo nice to hear.

-- 
Luben
