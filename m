From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: st.c block limits
Date: Thu, 1 Aug 2002 09:53:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF296EBF6E.70D07AAD-ON87256C08.005C4D3D@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-scsi@vger.kernel.org


>I mean that if the compression doesn't have "blocks" (like a gzip or
>compress algorithm), then you chose a more or less arbitrary block size.
>Say 1024 bytes.
>
>Then when compression of a block of data leads to an expansion, you
>just store a "0" bit, followed by the block. If the block size is 1024
>bytes, then this costs 1024.125 bytes of storage (8193 bits). If the
>compression /is/ succesful, then you just store a "1" bit followed by
>the compressed data (less than 1024 bytes....).

Oh, so you're talking about a way the tape drive could be engineered so we
wouldn't have to worry about expansion.  It sounded like you might be
talking about something a user of an existing tape drive could do to avoid
the problem.


BTW, one other reason that you wouldn't be able to fit 10GB on a nominally
10GB tape is defects in the medium, particularly those that arose after
manufacture.  The drive will automatically skip bad parts of the tape.



