From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v12 8/9] add TC G210 platform driver
Date: Fri, 8 Apr 2016 10:13:01 +0100
Message-ID: <5707761D.7000804@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <aa4c31ba977bc5c07f5706f12c4d9fbb1bb0ec36.1459448160.git.jpinto@synopsys.com>
 <20160404051546.GE17806@rob-hp-laptop> <57024677.2060009@synopsys.com>
 <20160407175708.GB32257@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407175708.GB32257@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Rob,

On 4/7/2016 6:57 PM, Rob Herring wrote:
> On Mon, Apr 04, 2016 at 11:48:23AM +0100, Joao Pinto wrote:
>>
>> Hi Rob,
>>
>> On 4/4/2016 6:15 AM, Rob Herring wrote:
>>> On Thu, Mar 31, 2016 at 07:57:21PM +0100, Joao Pinto wrote:
>>>> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
>>>>
>>>> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
>>>> ---
>>
>> [snip]
>>
>>>> +
>>>> +Required properties:
>>>> +- compatible	: compatible list must contain the PHY type & version:
>>>> +			"snps, g210-tc-6.00-20bit"
>>>> +			"snps, g210-tc-6.00-40bit"
>>> Remove the space              ^
>>>
>>>> +		  complemented with the Controller IP version:
>>>> +			"snps, dwc-ufshcd-1.40a"
>>>
>>> ditto
>>
>> Ok, will do that!
>>
>>>
>>> Combining the phy and controller compatible strings is a bit strange. 
>>> Generally, they would be separate nodes using the common phy binding.
>>>
>>
>> Correct, but in this case is just the compatibility string is just to tell the
>> dw ufs host that it has a 40-bit or a 20-bit test chip connected. The Test chip
>> is initialized by a unipro command sequence and there is no more ops related to it.
> 
> Okay. In that case, I think it should be a separate property unless the 
> controller h/w is synthesized for one or the other.

Yes, the hardware must be synthesized for a certain PHY type, 20 or 40-bit.

> 
> Rob
> 

Joao

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
