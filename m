From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 09:52:11 +0000
Message-ID: <510B904B.4050508@redhat.com>
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510B749E.8020501@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tao Ma <tm@tao.ma>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2013 07:54 AM, Bart Van Assche wrote:
>   * proc_scsi_write - handle writes to /proc/scsi/scsi
>   * @file: not used
>   * @buf: buffer to write
>   * @length: length of buf, at most PAGE_SIZE
>   * @ppos: not used
>   *
>   * Description: this provides a legacy mechanism to add or remove
>   * devices by Host, Channel, ID, and Lun.  To use,
>   * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
>   * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
>   * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.

The proc interface is deprecated; this can all be done via sysfs today, 
e.g.:

echo 1 > /sys/block/sdc/device/delete

Is equivalent to issuing scsi remove-single-device to proc.

Regards,
Bryn.
