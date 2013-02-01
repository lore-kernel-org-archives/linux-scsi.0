From: Tao Ma <tm@tao.ma>
Subject: Re: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 17:59:47 +0800
Message-ID: <510B9213.1040508@tao.ma>
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org> <510B904B.4050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510B904B.4050508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2013 05:52 PM, Bryn M. Reeves wrote:
> On 02/01/2013 07:54 AM, Bart Van Assche wrote:
>>   * proc_scsi_write - handle writes to /proc/scsi/scsi
>>   * @file: not used
>>   * @buf: buffer to write
>>   * @length: length of buf, at most PAGE_SIZE
>>   * @ppos: not used
>>   *
>>   * Description: this provides a legacy mechanism to add or remove
>>   * devices by Host, Channel, ID, and Lun.  To use,
>>   * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
>>   * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
>>   * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
> 
> The proc interface is deprecated; this can all be done via sysfs today,
> e.g.:
> 
> echo 1 > /sys/block/sdc/device/delete
> 
> Is equivalent to issuing scsi remove-single-device to proc.
yes, but the result is the same. It will do some IO first which will
cause this command hang.

Thanks,
Tao
> 
> Regards,
> Bryn.
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
