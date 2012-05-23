From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
Date: Wed, 23 May 2012 23:18:03 +0800
Message-ID: <CAF1ivSYTw19AEXmhAsvXp-vVk5ZGeFPzi9omBzCtYGKixNS5xw@mail.gmail.com>
References: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
	<Pine.LNX.4.44L0.1205231103030.1566-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205231103030.1566-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2012 at 11:03 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Wed, 23 May 2012, Lin Ming wrote:
>
>> Another thing need to check is if system suspend/resume works.
>
> Right! =A0Although I would hope that your work doesn't interfere at a=
ll
> with system sleep, since it touches only the runtime PM pathways.

sd_sync_cache and sd_start_stop_device are changed with REQ_PM set.
And they are called for system suspend too.

So it probably will have problem.

>
> Alan Stern
