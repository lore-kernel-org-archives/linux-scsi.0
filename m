From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2 00/38] cxlflash: OCXL transport support
Date: Fri, 9 Mar 2018 16:08:12 +1100
Message-ID: <6d69dab9-7f8d-0f4c-d276-d5cf2e882df6@au1.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <yq18tb5rskt.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <yq18tb5rskt.fsf@oracle.com>
Content-Language: en-AU
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On 07/03/18 05:01, Martin K. Petersen wrote:
> 
>> This patch series adds OCXL support to the cxlflash driver. With this
>> support, new devices using the OCXL transport will be supported by the
>> cxlflash driver along with the existing CXL devices. An effort is made
>> to keep this transport specific function independent of the existing
>> core driver that communicates with the AFU.
> 
> This one has been sitting for a week without any reviews. Andrew, when
> will you have time to take a look? >
> Being a pretty big chunk of code, I would like to merge it sooner rather
> than later. Or we can postpone until 4.18, of course.
> 

Slowly getting through it, though as of next Friday I'll be disappearing 
from the face of the earth for 3 weeks and I'm not sure I'll be finished 
by then.

Fred: could you take a look at this series if you have spare cycles?

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
