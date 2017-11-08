From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] tcmu: clean up the scatter helper
Date: Wed, 8 Nov 2017 16:44:19 -0600
Message-ID: <5A0388C3.8020702@redhat.com>
References: <1499927630-19785-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1501453144.1499.24.camel@haakon3.daterainc.com>
 <1ff87e2e-ad52-f985-e1cb-1d6cc26392b4@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1ff87e2e-ad52-f985-e1cb-1d6cc26392b4@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lixiubo@cmss.chinamobile.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/08/2017 04:39 PM, Bryant G. Ly wrote:
> On 7/30/17 5:19 PM, Nicholas A. Bellinger wrote:
> 
>> On Thu, 2017-07-13 at 14:33 +0800, lixiubo@cmss.chinamobile.com wrote:
>>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>>
>>> Add some comments to make the scatter code to be more readable.
>>>
>>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>> ---
>>>  drivers/target/target_core_user.c | 30 +++++++++++++++++++++++++-----
>>>  1 file changed, 25 insertions(+), 5 deletions(-)
>>>
>> Applied to target-pending/for-next.
>>
>> Thanks Xiubo + MNC.
>>
> This one seems to also be missing from the tree. 
> 

I ported this one to my patchset that is built without the
"tcmu: Add fifo type waiter list support to avoid starvation" patch:

https://www.spinics.net/lists/target-devel/msg16153.html
