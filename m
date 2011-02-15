From: Bokhan Artem <aptem@ngs.ru>
Subject: Re: sct erc does not work with megaraid
Date: Tue, 15 Feb 2011 22:00:52 +0600
Message-ID: <4D5AA334.7020301@ngs.ru>
References: <4D5A5388.3010208@ngs.ru> <4D5A9FE9.9020409@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D5A9FE9.9020409@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Only sct erc does not work. General communication using sat is function=
al.

15.02.2011 21:46, Douglas Gilbert =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> That code looked familiar but I'm not sure what your
> point was referring to it. Anyway ...
>
> Haven't worked much with Megaraid controllers but mptsas
> controllers implement SAT (or at least did) in their
> firmware. So upgrading the firmware on the controller fixed
> the problems I had (some years back) with SAT compliance.
>
> Doug Gilbert=20

