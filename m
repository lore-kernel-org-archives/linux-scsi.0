From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
Date: Thu, 09 Dec 2010 19:53:17 +0100
Message-ID: <4D01259D.2010409@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-6-git-send-email-tj@kernel.org> <4D011E05.5030205@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D011E05.5030205@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

Hello, Sergei.

On 12/09/2010 07:20 PM, Sergei Shtylyov wrote:
>> +    /*
>> +     * Media is considered to be present if TUR succeeds or fails with
>> +     * sense data indicating something other than media-not-present
>> +     * (ASC 0x3a).
>> +     */
>> +    if (!scsi_status_is_good(retval) &&
>> +        (!scsi_sense_valid(sshdr) || sshdr->asc == 0x3a)) {
>> +        /*
>> +         * Probably not media in the device.  Mark as changed, and
> 
>    s/not/no/

Updated patch already posted.  Thanks.

-- 
tejun
