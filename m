From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in
 target_get_sess_cmd()
Date: Mon, 16 Jul 2012 18:59:49 -0700
Message-ID: <1342490389.18004.383.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-6-git-send-email-roland@kernel.org>
	 <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
	 <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com>
	 <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 18:56 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2012-07-16 at 18:40 -0700, Roland Dreier wrote:
> > > OK, I'll take a look at how you handle this...
> > 
> > So looking at commit bc187ea6c3b3 in the tree you just pushed out
> > ("target: Check sess_tearing_down in target_get_sess_cmd()") it looks
> > like you just return from target_submit_cmd() if we fail to add the
> > command to sess_cmd_list -- doesn't this mean we just leak those
> > commands and possibly leave the HW sitting there with open exchanges?
> > 
> 
> With dropping patch #5 for now, I assume that would be the case..
> 

Or with patch #4 even..
