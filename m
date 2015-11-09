From: Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH v3 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Mon, 9 Nov 2015 15:26:34 +0100
Message-ID: <5640AD1A.70602@redhat.com>
References: <1447077232-5335-1-git-send-email-lvivier@redhat.com>
 <1447077232-5335-4-git-send-email-lvivier@redhat.com>
 <5640A7F6.6050201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5640A7F6.6050201@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 09/11/2015 15:04, Hannes Reinecke wrote:
> On 11/09/2015 02:53 PM, Laurent Vivier wrote:
>> QEMU allows until 32 LUNs.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 9 ++++++++-
>>  drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
> Nothing to do with QEMU; this is a driver limitation.
> Please fixup the description.

Yes, you're right, and I think I didn't define correctly the maximum
value, I use 31 instead of 32 as explained in include/scsi/scsi_host.h:

        /*
         * These three parameters can be used to allow for wide scsi,
         * and for host adapters that support multiple busses
         * The last two should be set to 1 more than the actual max id
         * or lun (e.g. 8 for SCSI parallel systems).
         */
        unsigned int max_channel;
        unsigned int max_id;
        u64 max_lun;

Laurent
