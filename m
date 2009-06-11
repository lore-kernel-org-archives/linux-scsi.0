From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: do Symmetrix multipath-tools defaults need update
	? or scsi-to-blk errors management ?
Date: Thu, 11 Jun 2009 00:11:02 -0500
Message-ID: <4A3091E6.40009@cs.wisc.edu>
References: <1614009620.1734931244696338438.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1614009620.1734931244696338438.JavaMail.root@zimbra16-e3.priv.proxad.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: device-mapper development <dm-devel@redhat.com>, Levy Jerome <Levy_Jerome@emc.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/10/2009 11:58 PM, christophe.varoqui@free.fr wrote:
>>> ::: error log on a 2.6.9 (rhel 4.7) kernel :::
>>>
>> For RH 4.9 I did the attached patch. So this error is not fastfailed
>> (upstream does not fastfail this type of error when using dm-multipath
>> now). So now the scsi layer will retry its normal 5 times, then fail.
>>
> Thank you for the information. This is very good news.
> Can you also advise about the rhel 5 minimum kernel version ?

It should be fixed in rhel 5.3 and the change was merged in upstream 
2.6.28 kernel.
