From: Itai Nahshon <nahshon@actcom.co.il>
Subject: Re: Fwd: Patch - SCSI host numbers - please apply
Date: Wed, 19 Jun 2002 03:03:45 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206190303.45188.nahshon@actcom.co.il>
References: <200206171604.57115.nahshon@actcom.co.il> <200206181514.52827.nahshon@actcom.co.il> <3D0FA398.8DA6C959@splentec.com>
Reply-To: nahshon@actcom.co.il
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D0FA398.8DA6C959@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday 19 June 2002 00:18 am, Luben Tuikov wrote:
> Itai,
>
>
> After applying your patch to 2.4.18, I see the following
> problems:

Well, I just tried that with 2.4.18-pre10 + my patch and I do not
see any of the problems that you described. I suspect there
is something wrong with your configuration or with the
way that you run your tests.

I first loaded ide-scsi (which got host_no 0) and then
the object that I got from compiling yout code with
MaxHosts=30 (and it got host_nos 1 .. 30).
Removng the modules worked OK too. The hosts were
unregistered and off course, no oops.
Then reloaded scsi_reg.o with MaxHosts=100. Again no
problem.

My configuration:
RedHat 7.2, non-SMP. All the updates from RedHat applied +KDE-3.0.
Relevant RPMS:
	gcc-2.96-98
	cpp-2.96-98
	binutils-2.11.90.0.8-11
	modutils-2.4.13-0.7.1

The kernel source tree is symbolic linked to /usr/src/linux .
Your code extracted to /usr/src/scsi_reg/ .


-- Itai

