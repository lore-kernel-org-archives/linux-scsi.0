From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v17 4/4] arm64: Add APM X-Gene SoC AHCI SATA host
 controller DTS entries
Date: Fri, 14 Mar 2014 12:42:17 +0100
Message-ID: <201403141242.17669.arnd@arndb.de>
References: <1394655573-32645-1-git-send-email-lho@apm.com>
 <1394655573-32645-4-git-send-email-lho@apm.com>
 <1394655573-32645-5-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1394655573-32645-5-git-send-email-lho@apm.com>
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
Cc: devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jcm@redhat.com, patches@apm.com, tj@kernel.org, ddutile@redhat.com, olof@lixom.net, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 12 March 2014, Loc Ho wrote:
> +                       sata01clk: sata01clk@1f21c000 {
> +                               compatible = "apm,xgene-device-clock";
> +                               #clock-cells = <1>;
> +                               clocks = <&socplldiv2 0>;
> +                               clock-names = "socplldiv2";
> +                               reg = <0x0 0x1f21c000 0x0 0x1000>;
> +                               reg-names = "csr-reg";
> +                               clock-output-names = "sata01clk";
> +                               csr-offset = <0x4>;
> +                               csr-mask = <0x05>;
> +                               enable-offset = <0x0>;
> +                               enable-mask = <0x39>;

Same comment about the "clock-names" as in the first patch here.

	Arnd
