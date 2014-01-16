From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 2/4] Documentation: Add documentation for APM X-Gene
 SoC SATA host controller DTS binding
Date: Thu, 16 Jan 2014 11:38:28 +0100
Message-ID: <3162202.3lfb3jYxiv@wuerfel>
References: <1389769910-15505-1-git-send-email-lho@apm.com>
 <CAPw-ZTmn-aNJcLd1mZPRtog_ncq=GC94ULCJb-400oYqERYK5g@mail.gmail.com>
 <CAPw-ZT=QXwOVvpgJSL5qU8J2eEuAt3nnXJDfDwPXTTo7z4Fe-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAPw-ZT=QXwOVvpgJSL5qU8J2eEuAt3nnXJDfDwPXTTo7z4Fe-A@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "jcm@redhat.com" <jcm@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "patches@apm.com" <patches@apm.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 15 January 2014 15:59:27 Loc Ho wrote:
> 
> May be I misread what Mark mentioned. The binding documentation should
> not specify the requirement of 0. And the binding of the dts should be
> as is:
> 
> phy1 {
>    #phy-cells = <1>;
> };
> 
> sata1 {
>    :::
>    phys = <&phy1 0>;     where 0 indicates the mode of operation?
> };
> 
> 

Yes, that is right. You can keep the zero in the example, but the
binding text must not require a specific phy to be used.

	Arnd
