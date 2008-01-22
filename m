From: "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 08:50:03 +0100
Message-ID: <e2e108260801212350h7308caccs4be0f519e1e9bb72@mail.gmail.com>
References: <20080117174542.GC29650@osc.edu> <479096D2.8090003@vlnb.net>
	<e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>
	<20080122122657R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <20080122122657R.fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Jan 22, 2008 4:26 AM, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> First, I recommend you to examine iSER stuff more since it has some
> parameters unlike SRP, which effects the performance, IIRC. At least,
> you could get the iSER performances similar to Pete's.

Documentation about configuring iSER parameters at the initiator side
appears to be hard to find. A Google query for (iscsiadm "op update"
"v iser" -- http://www.google.com/search?q=iscsiadm+%22op+update%22+%22v+iser%22)
gave only one result:
http://www.mail-archive.com/stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org/msg00033.html.
I also found an update of this document:
http://www.mail-archive.com/stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org/msg00133.html.

Are you referring to parameters like MaxRecvDataSegmentLength,
TargetRecvDataSegmentLength, InitiatorRecvDataSegmentLength and
MaxOutstandingUnexpectedPDUs as explained in RFC 5046
(http://www.ietf.org/rfc/rfc5046.txt) ?

It would be interesting for me to know which values Pete had
configured in his tests, such that I can configure the same values for
these parameters.

Bart.
