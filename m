From: Venkat Rao B <vrbagal1@linux.vnet.ibm.com>
Subject: Re: Fwd: [powerpc/Baremetal]Kernel OOPS while executing memory
 hotplug on Power8 baremetal
Date: Thu, 7 Jun 2018 12:56:53 +0530
Message-ID: <d011631b-c667-2628-dda8-2c87961329f0@linux.vnet.ibm.com>
References: <ee45ead1d96ad05f77aec1d8d3e39c85@linux.vnet.ibm.com>
 <d5b62afc48ece5aca8d08a80871c8613dd555d17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <d5b62afc48ece5aca8d08a80871c8613dd555d17.camel@wdc.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org



On Thursday 07 June 2018 12:46 PM, Bart Van Assche wrote:
> On Thu, 2018-06-07 at 12:38 +0530, vrbagal1 wrote:
>> Observing Kernel oops and machine reboots while executing memory hotplug
>> test case, on Power8 Baremetal machine.
>>
>> I see this is introduced some where between rc6 and 4.17.
> 
> Please provide the exact versions (git commit IDs) of the kernel versions
> you have tested.

Commit Id ---> 5037be168f

Regards,
Venkat
IBM Linux Technology Centre


> 
> Thanks,
> 
> Bart.
> 
> 
> 
> 
