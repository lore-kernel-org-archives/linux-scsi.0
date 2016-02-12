From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v7 3/3] add support for DWC UFS Host Controller
Date: Fri, 12 Feb 2016 17:52:08 +0000
Message-ID: <56BE1BC8.5020604@synopsys.com>
References: <cover.1455192008.git.jpinto@synopsys.com>
 <ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto@synopsys.com>
 <20160212163636.GA31045@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160212163636.GA31045@rob-hp-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Rob,

On 2/12/2016 4:36 PM, Rob Herring wrote:
> On Thu, Feb 11, 2016 at 12:13:06PM +0000, Joao Pinto wrote:
>> +Required properties:
>> +- compatible        : compatible string ("snps,ufshcd-1.0", "snps,ufshcd-1.1"
>> +  or "snps,ufshcd-2.0")
> 
> History has taught us this needs to have a vendor specific compatible 
> string as well. Don't necessarily have to define it now, but just state 
> a vendor string is needed too.

The compatibility string already as the "snps" which is the acronym for Synopsys
which is the HW Controller vendor. Isn't this enough?

> 
>> +- reg               : <registers mapping>
>> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
>> +
>> +Example:
>> +	ufs@0xd0000000 {
>> +		compatible = "snps,ufshcd-2.0";
>> +		reg = < 0xd0000000 0x10000 >;
>> +		interrupts = < 24 >;
>> +	};

Thanks,
Joao
