From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH v2 1/3] Encapsulate scsi_do_report_luns
Date: Tue, 19 Feb 2013 10:57:26 -0500
Message-ID: <5123A0E6.6090701@redhat.com>
References: <1361214952-28978-1-git-send-email-revers@redhat.com> <1361214952-28978-2-git-send-email-revers@redhat.com> <51232675.4090104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382Ab3BSP5c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 10:57:32 -0500
In-Reply-To: <51232675.4090104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 02/19/2013 02:15 AM, Bart Van Assche wrote:
> On 02/18/13 20:15, Rob Evers wrote:
>> +    /*
>> +     * bytes 6 - 9: length of the command.
>> +     */
>> +    scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
>> +    scsi_cmd[7] = (unsigned char) (length >> 16) & 0xff;
>> +    scsi_cmd[8] = (unsigned char) (length >> 8) & 0xff;
>> +    scsi_cmd[9] = (unsigned char) length & 0xff;
>
> Have you considered using put_unaligned_be32() here ?
>
> Bart.

Thanks for the suggestion Bart.

James,

Are you in favor of the type of change
Bart is suggesting?

I thought I saw some email a while back where
you disagreed with stylistic only changes to existing
code.  Is that true and does it apply here?

Rob
