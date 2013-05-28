From: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH V2 2/9] Documentation: devicetree: Add DT bindings for
 UFS host controller
Date: Mon, 27 May 2013 22:31:40 -0700
Message-ID: <20130528053140.GA18476@quad.lixom.net>
References: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
 <1368515328-31535-3-git-send-email-draviv@codeaurora.org>
 <CAOesGMij6oKDr0BCRAnmz-r48S5FzzMcU_iyCyCyqkafWsmyNA@mail.gmail.com>
 <51933768.20107@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51933768.20107-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/devicetree-discuss>,
 <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/devicetree-discuss/>
List-Post: <mailto:devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Help: <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/devicetree-discuss>,
 <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=subscribe>
Errors-To: devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Sender: "devicetree-discuss"
 <devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
To: Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, DOCUMENTATION <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:OPEN FIRMWARE AND..." <devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 15, 2013 at 12:51:12PM +0530, Sujit Reddy Thumma wrote:
> On 5/14/2013 11:38 PM, Olof Johansson wrote:
> >On Tue, May 14, 2013 at 12:08 AM, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> >>Compatible list is used in commit 03b1781 but is not documented.
> >>Add necessary device tree bindings to describe on-chip UFS host
> >>controllers.
> >>
> >>Signed-off-by: Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >>
> >>diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> >>new file mode 100644
> >>index 0000000..20468b2
> >>--- /dev/null
> >>+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> >>@@ -0,0 +1,16 @@
> >>+* Universal Flash Storage (UFS) Host Controller
> >>+
> >>+UFSHC nodes are defined to describe on-chip UFS host controllers.
> >>+Each UFS controller instance should have its own node.
> >>+
> >>+Required properties:
> >>+- compatible        : compatible list, contains "jedec,ufs-1.1"
> >>+- interrupts        : <interrupt mapping for UFS host controller IRQ>
> >>+- reg               : <registers mapping>
> >>+
> >>+Example:
> >>+       ufshc@0xfc598000 {
> >>+               compatible = "jedec,ufs-1.1";
> >
> >Hmm.
> >
> >Does jedec really specify the programming interface of this type of
> >device, register layout and meaning? It seems to be more about the
> >command set and electrical/connectivity specifications, no?
> 
> That's true with UFS device specification. For UFS Host Controller
> specification Jedec indeed standardized the hardware registers,
> memory structures and register programming sequence to talk to UFS
> device.

Ok, fair enough. However, I think "jedec,ufshc-1.1" would be more
appropriate to avoid ambiguities. Compare to SD where "sdhci" is the
only compatible string used for the standard interface.


-Olof
