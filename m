From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: Kernel build problem
Date: Wed, 01 Sep 2004 09:23:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409011623.i81GNtSC011621@bach.leonora.org>
References: <2A9AA9C52024F94A96634E39B9858FF166B969@empwilex1.empirix.com>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:55276
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S267601AbUIAQYC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 12:24:02 -0400
In-Reply-To: Your message of "Wed, 01 Sep 2004 11:57:06 EDT."
             <2A9AA9C52024F94A96634E39B9858FF166B969@empwilex1.empirix.com>
List-Id: linux-scsi@vger.kernel.org
To: "Dunn, Charles" <CDunn@empirix.com>
Cc: linux-scsi@vger.kernel.org

To be fair, it's not really a Red Hat issue, but rather Linus's belief
that debuggers lead to patching symptoms rather than fixing the
underlying problem.

--- Vladimir

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014

>>>>> "cd" == Charles Dunn <Dunn> writes:

    >> It is a pity that
    >> RedHat do not want kdb, it means that RH users have a lot of trouble
    >> trying to debug their systems.  OTOH SuSE are happy to include kdb in
    >> their distributions.
    cd> 
    cd> I agree 1000%! I went around and around with RH sales about this. No
    cd> complaints about the sales person, she really tried to get to the bottom
    cd> of why this is the way it is, and she even found the answer.. In talking
    cd> with her it was clear that in 99% of her conversations with RH engineers
    cd> the attitude was one of: "Debuggers produce bad fixes. Always. Debuggers
    cd> are evil.".. 
    cd> 
    cd> This is like blaming forks for a person being overweight. Any tool can
    cd> be used badly. No debugger is a substitute for understanding the code
    cd> and producing a good solution. But a debugger can illuminate specific
    cd> problem causes and shorten the debug cycle like few other tools can...
    cd> This whole debugger thing with RH has been frustrating beyond words. We
    cd> may even switch from RH to SuSe because of this, but mostly because RH
    cd> seems to enjoy making life hard for embedded products makers who want to
    cd> use RH. We are building VoIP test equipment and want to use RH as the OS
    cd> inside.. They are making us jump through hoops that Microsoft hasn't
    cd> even thought of yet. It's getting close to the point where it would be
    cd> cheaper per  box sold to have Windows inside than Linux.. Am I crazy or
    cd> is that just a tad upside down from where Linux is supposed to be
    cd> going???
    cd> 
    cd> -Charlie Dunn
    cd>  Empirix Inc.
    cd> 
    cd> 
    cd> 
    cd> ---------------------------
    cd> Use http://oss.sgi.com/ecartis to modify your settings or to unsubscribe.
