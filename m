From: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: [PATCH] Allow SCSI_WAIT_SCAN to be deselected
Date: Fri, 14 Nov 2008 12:23:22 -0000
Message-ID: <0cff1148a04c9f90c98e26eff6e0bfc968e4574c@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
References: <1226585472-12559-1-git-send-email-bwalle@suse.de>
    <b637ec0b0811130618o2f76e34bh17055f2f165d89a5@mail.gmail.com>
    <491C3813.1070305@movial.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754569AbYKNMXu@vger.kernel.org>
In-Reply-To: <491C3813.1070305@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Bernhard Walle <bwalle@suse.de>, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, November 13, 2008 14:22, Dmitri Vorobiev wrote:
> Fabio Comolli wrote:
>> So I'm not the only one :-)
>> Please see this thread:
>>
>> http://lkml.org/lkml/2008/10/22/355
>
> See also:
>
> http://marc.info/?l=linux-scsi&m=122538386519971&w=2
> http://marc.info/?l=linux-scsi&m=122539443509753&w=2

I suggest reading http://lkml.org/lkml/2007/5/13/75.

Basically, if you want to get rid of it you need to provide
a viable alternative. (Loading a module is not the right
way to call a kernel function...) Then it could be default
'n' and marked as deprecated.

-- 
Simon Arlott
