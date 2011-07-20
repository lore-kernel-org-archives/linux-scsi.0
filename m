From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH SCSI] sr: check_events() ignore GET_EVENT when TUR says otherwise
Date: Wed, 20 Jul 2011 18:42:06 +0200
Message-ID: <CAPXgP11R=386wbqpOpymzdXYYhpvJg9Aj1Xck3wi91smud-8iA@mail.gmail.com>
References: <20110630130348.GQ3386@htj.dyndns.org> <20110720163308.GC9924@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20110720163308.GC9924@mtj.dyndns.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, maggu2810@googlemail.com, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 20, 2011 at 18:33, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jun 30, 2011 at 03:03:48PM +0200, Tejun Heo wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>>
>> Some broken devices indicates that media has changed on every
>> GET_EVENT_STATUS_NOTIFICATION. =C2=A0This translates into MEDIA_CHAN=
GE
>> uevent on every open() which lets udev run into a loop.
>>
>> Verify GET_EVENT result against TUR and if it generates spurious
>> events for several times in a row, ignore the GET_EVENT events, and
>> trust only the TUR status.

> James, ping.

This is a rather urgent fix, that needs to go in, and also to -stable.

Systems run into endless loops with ever-growing event queues. Nothing
really works any more if we hit that condition, unless the (broken)
device is disconnected.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
