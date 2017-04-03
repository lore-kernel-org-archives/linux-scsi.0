From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH v2] scsi: storvsc: Add support for FC rport.
Date: Mon, 3 Apr 2017 09:14:02 -0400
Message-ID: <58E24A9A.30200@redhat.com>
References: <1491219195-3692-1-git-send-email-cavery@redhat.com>
 <20170403121718.GA13130@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170403121718.GA13130@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, stephen@networkplumber.org, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/03/2017 08:17 AM, Christoph Hellwig wrote:
>>   	if (host->transportt == fc_transport_template) {
>> +		struct fc_rport_identifiers ids = {
>> +			.roles = FC_PORT_ROLE_FCP_TARGET,
>> +		};
> I don't think storvsc ever acts as FCP target.

In order to implement the work around so that the scsi scan works 
indicating FC_PORT_ROLE_FCP_TARGET as a role was necessary due to its 
test in fc_scsi_scan_rport. The idea here is to avoid making any changes 
to the fc_transport driver which was of some concern.


Thanks,

Cathy
