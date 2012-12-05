From: Daniel Vacek <neelx.g@gmail.com>
Subject: Re: [PATCH 1/2] megaraid: fix BUG_ON() from incorrect use of delayed work
Date: Wed, 5 Dec 2012 12:16:12 +0100
Message-ID: <CAA7rmPHEcA0n=_Hhuhzk7LpwigUJ7WGota2en5KNQTb4hnthww@mail.gmail.com>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
	<20121204155434.GE3885@mtj.dyndns.org>
	<CAA7rmPF0NNxRQr0N7FgP=7NW7iy77HhEy46_T74kTcAdB6rvSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAA7rmPF0NNxRQr0N7FgP=7NW7iy77HhEy46_T74kTcAdB6rvSg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 5, 2012 at 12:02 PM, Daniel Vacek <neelx.g@gmail.com> wrote:
> On Tue, Dec 4, 2012 at 4:54 PM, Tejun Heo <tj@kernel.org> wrote:
>> @@ -5190,7 +5188,7 @@ static void
>>  megasas_aen_polling(struct work_struct *work)
>>  {
>>         struct megasas_aen_event *ev =
>> -               container_of(work, struct megasas_aen_event, hotplug_work);
>> +               container_of(work, struct megasas_aen_event, hotplug_work.work);
>>         struct megasas_instance *instance = ev->instance;
>>         union megasas_evt_class_locale class_locale;
>>         struct  Scsi_Host *host;
>
> -megasas_aen_polling(struct work_struct *work)
> +megasas_aen_polling(struct delayed_work *work)
>
> Not really sure. Just asking?

Never mind, it's ok. Now I get it. Sorry for the buzz.

--nX
