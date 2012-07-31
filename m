From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Tue, 31 Jul 2012 11:20:19 -0500
Message-ID: <501805C3.7030504@linux.vnet.ibm.com>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
 <1343611946.21647.23.camel@pasglop> <20120730190606.GD3155@aepfle.de>
 <1343704122.8227.3.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1343704122.8227.3.camel@pasglop>
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
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Olaf Hering <olaf@aepfle.de>, Brian J King <bjking1@us.ibm.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linuxppc-dev@ozlabs.org, Robert C Jennings <rcjenn@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 07/30/2012 10:08 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2012-07-30 at 21:06 +0200, Olaf Hering wrote:
>>> So while this would work, I do wonder however whether we could
>> instead
>>> fix it by simplifying the whole thing as follow since iSeries is now
>>> gone and so we don't need split backends anymore:
>>>
>>> scsi/ibmvscsi: Remove backend abstraction
>>
>> I cant that these things myself anymore.
> 
> Brian, can somebody from your side own these ?

I talked to Rob and he will be picking this up. Rob - can you submit
a patch to the maintainers file, adding yourself as the ibmvscsi maintainer?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
