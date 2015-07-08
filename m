From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 15:02:55 +0300
Message-ID: <559D116F.9070604@dev.mellanox.co.il>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <20150708101931.GD14466@infradead.org> <559CFD14.9090803@dev.mellanox.co.il>
 <20150708104955.GA20842@infradead.org> <559D0286.4070202@suse.de>
 <20150708114424.GA13943@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150708114424.GA13943@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On 7/8/2015 2:44 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 12:59:18PM +0200, Hannes Reinecke wrote:
>> Actually it's controlled by the D_SENSE bit in the Control mode page
>> (that's bit[2] of byte 2 in the control mode page).
>> Which is currently set to '0', ie we will be returning fixed sense
>> information.
>> _If_ we were to report descriptor sense we will need to change that,
>> too.
>
> Just looked over SPC, and indeed D_SENSE is a strict either fixed
> or descriptor, not a may return descriptor data.
>
> So this patch actually is wrong as we never must return different sense
> data types based on the sense code.
>

I'll send out v4 without this patch altogether.
